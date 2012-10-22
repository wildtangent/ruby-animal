require 'pony'

class Mailer
  
  def self.send_error_mail(e)
    Pony.mail({
      :to => 'developers@livestation.com',
      :via => :smtp,
      :via_options => {
        :address              => 'smtp.gmail.com',
        :port                 => '587',
        :enable_starttls_auto => true,
        :user_name            => 'daniel.van.dommelen',
        :password             => 'c6vic9x3##',
        :authentication       => :plain,
        :domain               => "localhost.localdomain"
      },
      :body => %(
        The OCR service is down!
        
        #{e.inspect}
      )
    })
  end
  
end