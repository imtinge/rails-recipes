module RegistrationsHelper

	def has_error?(form, attr)
		(form.object.errors[attr].any?)? "has-error" : ""
	end

  def display_status?
    params[:status].blank? ? "active" : ""
  end

  def display_ticket_id?
    params[:ticket_id].blank? ? "active" : ""
  end

  def display_status_active?(s)
    params[:status] == s ? "active" : ""
  end

  def display_ticket_id_active?(t)
    params[:ticket_id].to_i == t.id ? "active" : ""
  end

end
