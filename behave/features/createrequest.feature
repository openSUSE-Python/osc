Feature: `osc createrequest` command


# common steps for all scenarios
Background:
   Given I set working directory to "{context.osc.temp}"
    And I execute osc with args "branch test:factory/test-pkgA"
    # the package gets forked from the devel project!
    And I execute osc with args "co home:Admin:branches:test:devel/test-pkgA"
    And I set working directory to "{context.osc.temp}/home:Admin:branches:test:devel/test-pkgA"


@destructive
Scenario: Run `osc createrequest`
   When I create file "{context.osc.temp}/home:Admin:branches:test:devel/test-pkgA/new_file" with perms "0644"
        """
        """
    And I execute osc with args "add new_file"
    And I execute osc with args "ci -m 'commit description'"
    And I execute osc with args "createrequest -a submit -m 'request description'"
   Then the exit code is 0


@destructive
Scenario: Run `osc createrequest --supersede`
  Given I create file "{context.osc.temp}/home:Admin:branches:test:devel/test-pkgA/new_file" with perms "0644"
        """
        """
    And I execute osc with args "add new_file"
    And I execute osc with args "ci -m 'commit description'"
    And I execute osc with args "createrequest -a submit -m 'request description'"
    And the exit code is 0
    And I execute osc with args "api /request/1"
    And stdout doesn't contain "<state name=\"superseded\">"
   When I create file "{context.osc.temp}/home:Admin:branches:test:devel/test-pkgA/another_file" with perms "0644"
        """
        """
    And I execute osc with args "add new_file"
    And I execute osc with args "ci -m 'commit description'"
    And I execute osc with args "createrequest -a submit -m 'request description' --supersede 1"
   Then the exit code is 0
    And I execute osc with args "api /request/1"
    And stdout contains "<state name=\"superseded\".*superseded_by=\"2\">"
