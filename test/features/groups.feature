Feature: Groups
  Given I am logged in as an admin

  Scenario: List all groups
    Given that a group with the name "Marketing" exists
    When I visit the groups page
    Then I should see "Marketing" in the list of groups

  Scenario: Create a new group
    When I create a new group with the name "Marketing"
    Then the new group "Marketing" is listing on the groups page

  Scenario: Changing the name of a group
    Given that a group with the name "Marketing" exists
    When I edit the group "Marketing" and change the name to "Sales"
    Then the group "Marketing" is renamed to "Sales"

  Scenario: Delete an existing group
    Given that a group with the name "Sales" exists
    When I delete the group "Sales"
    Then the group "Sales" is not listing on the groups page
