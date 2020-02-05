Feature: TuringMachine demonstrates proper functions without crashing
	Scenario: TuringMachine implements a simple TM per Chapter 19
		Given a file named "beginswitha.txt" with:
			"""
			# begins with a
			1 Start, a, a, R, 2
			2, a, a, R, 2
			2, b, b, R, 2
			2, _, _, R, Halt
			Halt
			"""
		When I run `turingmachine beginswitha.txt "aaa"`
		Then the output should match /Accepted: aaa/
		And I run `turingmachine beginswitha.txt "abba"`
		Then the output should match /Accepted: abba/
		And I run `turingmachine beginswitha.txt "ababab"`
		Then the output should match /Accepted: ababab/
		Then 20 points are awarded

	Scenario: TuringMachine rejects on no valid transition
		Given a file named "alla.txt" with:
			"""
			# All a's
			Start, a, a, R, 2
			2, a, a, R, 2
			2, _, _, R, Halt

			"""
		When I run `turingmachine alla.txt "b"`
		Then the output should match /Rejected: b/
		And I run `turingmachine alla.txt "ab"`
		Then the output should match /Rejected: ab/
		And I run `turingmachine alla.txt "aaaab"`
		Then the output should match /Rejected: aaaab/
		And I run `turingmachine alla.txt "aaaa"`
		Then the output should match /Accepted: aaaa/
		Then 40 points are awarded

	Scenario: TuringMachine rejects on no valid transition
		Given a file named "tapehead.txt" with:
			"""
			# Tape head check: goes backwards after a first b
			Start, a, a, R, 2
			Start, b, b, L, 3
			2, a, a, R, 2
			2, b, b, L, 3
			3, a, a, L, 3
			3, b, b, L, 3
			3, _, _, L, 3
			"""
		When I run `turingmachine tapehead.txt "b"`
		Then the output should match /Rejected: b/
		And I run `turingmachine tapehead.txt "abaa"`
		Then the output should match /Rejected: abaa/
		And I run `turingmachine tapehead.txt "aaaab"`
		Then the output should match /Rejected: aaaab/
		Then 40 points are awarded

	Scenario: TuringMachine rejects on > 1,000 transitions 
		Given a file named "loop.txt" with:
			"""
			# Loops on anything with an a in it
			Start, a, a, R, 3
			Start, b, b, R, 2
			2, a, a, R, 3
			2, b, b, R, 2
			2, _, _, R, Halt
			3, a, a, R, 3
			3, b, b, R, 3
			3, _, _, R, 3
			Halt
			"""
		When I run `turingmachine loop.txt "a"`
		Then the output should match /Rejected: a/
		And I run `turingmachine loop.txt "bbbbba"`
		Then the output should match /Rejected: bbbbba/
		And I run `turingmachine loop.txt "bbb"`
		Then the output should match /Accepted: bbb/
		Then 40 points are awarded

	Scenario: TuringMachine accepts any aNbNaN
		Given a file named "anbnan.txt" with:
			"""
			#aNbNaN
			1 Start, a, *, R, 2
			1 Start, _, _, R, Halt
			2, a, a, R, 2
			2, b, b, R, 3
			3, b, b, R, 3
			3, a, a, L, 4
			4, b, a, R, 5
			5, a, a, R, 5
			5, _, _, L, 6
			6, a, _, L, 7
			7, a, _, L, 8
			8, a, a, L, 8
			8, b, b, L, 8
			8, *, *, R, 1 Start
			"""
		When I run `turingmachine anbnan.txt "aba"`
		Then the output should match /Accepted: aba/
		And I run `turingmachine anbnan.txt "aaabbbaaa"`
		Then the output should match /Accepted: aaabbbaaa/
		And I run `turingmachine anbnan.txt "aabba"`
		Then the output should match /Rejected: aabba/
		Then 40 points are awarded


