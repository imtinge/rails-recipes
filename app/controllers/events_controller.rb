class EventsController < ApplicationController

  def index
    # @events = Event.rank(:row_order).all
    @events = Event.only_public.rank(:row_order).all
  end

  def show
    # @event = Event.find_by_friendly_id!(params[:id])
    @event = Event.only_available.find_by_friendly_id!(params[:id])
    colors = ['rgba(255, 99, 132, 0.2)',
              'rgba(54, 162, 235, 0.2)',
              'rgba(255, 206, 86, 0.2)',
              'rgba(75, 192, 192, 0.2)',
              'rgba(153, 102, 255, 0.2)',
              'rgba(255, 159, 64, 0.2)'
              ]
    ticket_names = @event.tickets.map { |t| t.name }

   status_colors = { "confirmed" => "#FF6384",
                      "pending" => "#36A2EB"}

   @data1 = {
       labels: ticket_names,
       datasets: Registration::STATUS.map do |s|
         {
           label: I18n.t(s, :scope => "registration.status"),
           data: @event.tickets.map{ |t| t.registrations.by_status(s).count },
           backgroundColor: status_colors[s],
           borderWidth: 1
         }
       end
   }
   @data2 = {
       labels: ticket_names,
       datasets: [{
           label: '# of Amount',
           data:  @event.tickets.map{ |t| t.registrations.by_status("confirmed").count * t.price },
           backgroundColor: colors,
           borderWidth: 1
       }]
   }
  end

end
