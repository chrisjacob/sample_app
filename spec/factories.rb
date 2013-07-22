FactoryGirl.define do
	factory :user do
		name 		"Chris Jacob"
		email 		"chris@example.com"
		password 	"foobar"
		password_confirmation "foobar"
	end
end