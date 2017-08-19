class Admin::EventsController < AdminController
  before_action :require_editor!

  def index
    @events = Event.rank(:row_order).all
  end

  def show
    @event = Event.find_by_friendly_id!(params[:id])
    if @event.registrations.any?
      dates = (@event.registrations.order("id ASC").first.created_at.to_date..Date.today).to_a
      status_colors = { "confirmed" => "#FF6384",
                        "pending" => "#36A2EB"}
      @data3 = {
        labels: dates,
        datasets: Registration::STATUS.map do |s|
          {
            :label => I18n.t(s, :scope => "registration.status"),
            :data => dates.map{ |d|
              @event.registrations.by_status(s).where( "created_at >= ? AND created_at <= ?", d.beginning_of_day, d.end_of_day).count
            },
            borderColor: status_colors[s]
          }
        end
      }
    end
  end

  def new
    @event = Event.new
    @event.tickets.build
    @event.attachments.build
  end

  def create
    @event = Event.new(event_params)

    if @event.save
      redirect_to admin_events_path
    else
      render "new"
    end
  end

  def edit
    @event = Event.find_by_friendly_id!(params[:id])
    @event.tickets.build if @event.tickets.empty?
    @event.attachments.build if @event.attachments.empty?
  end

  def update
    @event = Event.find_by_friendly_id!(params[:id])

    if @event.update(event_params)
      redirect_to admin_events_path
    else
      render "edit"
    end
  end

  def destroy
    @event = Event.find_by_friendly_id!(params[:id])
    @event.destroy

    redirect_to admin_events_path
  end

  def bulk_update
    total = 0
    (params[:ids]).to_a.each do |event_id|
      event = Event.find(event_id)
      if params[:commit] == I18n.t(:bulk_update)
        event.status = params[:event_status]
        if event.save
          total += 1
        end
      elsif params[:commit] == I18n.t(:bulk_delete)
        event.destroy
        total += 1
      end
    end

    flash[:alert] = "成功完成 #{total} 笔"
    redirect_to admin_events_path
  end

  def reorder
    @event = Event.find_by_friendly_id!(params[:id])
    @event.row_order_position = params[:position]
    @event.save!

    respond_to do |format|
      format.html { redirect_to admin_events_path }
      format.json { render json: { message: 'ok' } }
    end
  end

  protected

  def event_params
    params.require(:event).permit(:name, :logo, :remove_logo, :remove_images, :description, :friendly_id, :status, :category_id,
                                  images: [], tickets_attributes: [:id, :name, :description, :price, :_destroy], attachments_attributes: [:id, :attachment, :description, :_destroy])
  end

end
