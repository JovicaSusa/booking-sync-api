require 'rails_helper'

RSpec.describe Booking, type: :model do
  it { should validate_presence_of(:start_at) }
  it { should validate_presence_of(:end_at) }
  it { should validate_presence_of(:client_email) }
  it { should validate_presence_of(:price) }
  it { should validate_presence_of(:rental) }
end
