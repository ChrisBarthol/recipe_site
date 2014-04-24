Feature: Sign out
	User signs out

	Scenario: User signs out
		Given I am an authenticated user
		When I sign out
		Then I am redirect to home