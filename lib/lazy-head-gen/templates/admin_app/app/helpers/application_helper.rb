# Helper methods defined here can be accessed in any controller or view in the application

Admin.helpers do

  # Translates default Padrino flash keys into default Twitter Bootstrap
  # alert CSS class name extension.
  #
  # @param [Symbol] flash - The flash key
  # @return [String] the CSS class name
  def bootstrap_alert_for(flash)
    case flash
      when :error
        return "error"
      when :warning
        return "block"
      when :notice
        return "success"
      when :info
        return "info"
    end
  end

end