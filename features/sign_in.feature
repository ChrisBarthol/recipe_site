Feature: Sign in
	User signs in

	Scenario: User signs in
		Given I am not logged in
		When I sign-in
		Then I should see "Welcome to your Dashboard"