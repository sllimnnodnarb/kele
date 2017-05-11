require 'httparty'
require 'json'
require './lib/roadmap.rb'

class Kele

include HTTParty
include Roadmap

  def initialize(email, password)
    response = self.class.post("https://www.bloc.io/api/v1/sessions", body: { email: email, password: password })
    @auth_token = response["auth_token"]
    raise "Wrong email and/or password" if @auth_token.nil?
  end

  def get_me
    response = self.class.get("https://www.bloc.io/api/v1/users/me", headers: { "authorization" => @auth_token })
    @parsed_response = JSON.parse(response.body)
  end

  def get_mentor_availability(mentor_id)
    @mentor_id = mentor_id
    response = self.class.get("https://www.bloc.io/api/v1/mentors/#{@mentor_id}/student_availability", headers: { "authorization" => @auth_token })
    @mentor_timeslots = JSON.parse(response.body)
    timeslots = []
    @mentor_timeslots.each do |timeslot|
      if timeslot["booked"] == nil
          timeslots << timeslot
        else
          puts 'your mentor aint got time for anyone else bro, hes full up'
      end
    end
    puts timeslots
  end

  def get_messages(page = 0)
    if page != 0
      response = self.class.get("https://www.bloc.io/api/v1/message_threads", headers: { "authorization" => @auth_token })
    else
      response = self.class.get("https://www.bloc.io/api/v1/message_threads?page=#{page}", headers: { "authorization" => @auth_token })
    end
    @messages = JSON.parse(response.body)
  end

  def create_message(user_id, recipient_id, subject, stripped_text)
    response = self.class.post("https://www.bloc.io/api/v1/messages", headers: { "authorization" => @auth_token }, body: { user_id: user_id, recipient_id: recipient_id, subject: subject, "stripped-text" => stripped_text })
    if response.success?
      puts "message sent successfully"
    else
      puts "message not sent"
    end
  end

end
