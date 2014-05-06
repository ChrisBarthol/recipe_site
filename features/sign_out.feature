Feature: Sign out
	User signs out

	Scenario: User signs out
		Given I am an authenticated user
		When I sign out
		Then I should see "How often do you throw out food in your house?"