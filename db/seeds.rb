def users
  @users ||= User.all
end

ActiveRecord::Base.transaction do
  2.times { FactoryBot.create(:user) }

  10.times do
    flower = FactoryBot.create(:flower)

    3.times do
      FactoryBot.create(:sighting, flower: flower, user: users.sample)
    end
  end
end
