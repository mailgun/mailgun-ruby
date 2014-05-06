require 'spec_helper'

describe 'The method generate_hash' do
  before(:each) do
    @mailing_list = "mylist@example.com"
    @secret_app_id = "mysupersecretpassword"
    @recipient_address = "bob@example.com"
    @precalculated_hash = "eyJoIjoiMmY3ZmY1MzFlOGJmMjA0OWNhMTI3ZmU4ZTQyNjZkOTljYzhkMTdk%0AMiIsInAiOiJleUpzSWpvaWJYbHNhWE4wUUdWNFlXMXdiR1V1WTI5dElpd2lj%0AaUk2SW1KdllrQmxlR0Z0Y0d4bExtTnZcbmJTSjlcbiJ9%0A"
  end

  it 'generates a web safe hash for the recipient wishing to subscribe' do
    my_hash = Mailgun::OptInHandler.generate_hash(@mailing_list, @secret_app_id, @recipient_address)
    my_hash.should eq(@precalculated_hash)
  end

  it 'generates a web safe hash for the recipient wishing to subscribe' do
    validate_result = Mailgun::OptInHandler.validate_hash(@secret_app_id, @precalculated_hash)
    validate_result.length.should eq(2)
    validate_result['recipient_address'].should eq(@recipient_address)
    validate_result['mailing_list'].should eq(@mailing_list)
  end
end
