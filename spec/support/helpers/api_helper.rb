module ApiHelper
  def send_and_accept_json
    header 'Accept', 'application/json'
    header 'Content-Type', 'application/json'
  end

  def decoded_response
    decoded = Oj.load(last_response.body)

    if decoded.is_a?(Array)
      decoded.map(&:with_indifferent_access)
    else
      decoded.with_indifferent_access
    end
  end
end

