============================= test session starts ==============================
platform linux -- Python 3.8.18, pytest-6.2.5, py-1.10.0, pluggy-1.0.0 -- /home/subzero/Desktop/bhel/fyle-interview-intern-backend/env/bin/python
cachedir: .pytest_cache
rootdir: /home/subzero/Desktop/bhel/fyle-interview-intern-backend, configfile: pytest.ini
plugins: cov-2.12.1
collecting ... collected 18 items

tests/principals_test.py::test_get_assignments PASSED
tests/principals_test.py::test_grade_assignment_draft_assignment FAILED
tests/principals_test.py::test_grade_assignment FAILED
tests/principals_test.py::test_regrade_assignment FAILED
tests/students_test.py::test_get_assignments_student_1 PASSED
tests/students_test.py::test_get_assignments_student_2 PASSED
tests/students_test.py::test_post_assignment_null_content FAILED
tests/students_test.py::test_post_assignment_student_1 PASSED
tests/students_test.py::test_submit_assignment_student_1 FAILED
tests/students_test.py::test_assignment_resubmit_error FAILED
tests/teachers_test.py::test_get_assignments_teacher_1 PASSED
tests/teachers_test.py::test_get_assignments_teacher_2 FAILED
tests/teachers_test.py::test_grade_assignment_cross FAILED
tests/teachers_test.py::test_grade_assignment_bad_grade PASSED
tests/teachers_test.py::test_grade_assignment_bad_assignment PASSED
tests/teachers_test.py::test_grade_assignment_draft_assignment FAILED
tests/SQL/sql_test.py::test_get_assignments_in_various_states FAILED
tests/SQL/sql_test.py::test_get_grade_A_assignments_for_teacher_with_max_grading FAILED

=================================== FAILURES ===================================
____________________ test_grade_assignment_draft_assignment ____________________

client = <FlaskClient <Flask 'core'>>
h_principal = {'X-Principal': '{"principal_id": 1, "user_id": 5}'}

    def test_grade_assignment_draft_assignment(client, h_principal):
        """
        failure case: If an assignment is in Draft state, it cannot be graded by principal
        """
        response = client.post(
            '/principal/assignments/grade',
            json={
                'id': 5,
                'grade': GradeEnum.A.value
            },
            headers=h_principal
        )
    
>       assert response.status_code == 400
E       assert 404 == 400
E         +404
E         -400

tests/principals_test.py:30: AssertionError
____________________________ test_grade_assignment _____________________________

client = <FlaskClient <Flask 'core'>>
h_principal = {'X-Principal': '{"principal_id": 1, "user_id": 5}'}

    def test_grade_assignment(client, h_principal):
        response = client.post(
            '/principal/assignments/grade',
            json={
                'id': 4,
                'grade': GradeEnum.C.value
            },
            headers=h_principal
        )
    
>       assert response.status_code == 200
E       assert 404 == 200
E         +404
E         -200

tests/principals_test.py:43: AssertionError
___________________________ test_regrade_assignment ____________________________

client = <FlaskClient <Flask 'core'>>
h_principal = {'X-Principal': '{"principal_id": 1, "user_id": 5}'}

    def test_regrade_assignment(client, h_principal):
        response = client.post(
            '/principal/assignments/grade',
            json={
                'id': 4,
                'grade': GradeEnum.B.value
            },
            headers=h_principal
        )
    
>       assert response.status_code == 200
E       assert 404 == 200
E         +404
E         -200

tests/principals_test.py:59: AssertionError
______________________ test_post_assignment_null_content _______________________

client = <FlaskClient <Flask 'core'>>
h_student_1 = {'X-Principal': '{"student_id": 1, "user_id": 1}'}

    def test_post_assignment_null_content(client, h_student_1):
        """
        failure case: content cannot be null
        """
    
        response = client.post(
            '/student/assignments',
            headers=h_student_1,
            json={
                'content': None
            })
    
>       assert response.status_code == 400
E       assert 200 == 400
E         +200
E         -400

tests/students_test.py:39: AssertionError
_______________________ test_submit_assignment_student_1 _______________________

client = <FlaskClient <Flask 'core'>>
h_student_1 = {'X-Principal': '{"student_id": 1, "user_id": 1}'}

    def test_submit_assignment_student_1(client, h_student_1):
        response = client.post(
            '/student/assignments/submit',
            headers=h_student_1,
            json={
                'id': 2,
                'teacher_id': 2
            })
    
        assert response.status_code == 200
    
        data = response.json['data']
        assert data['student_id'] == 1
>       assert data['state'] == 'SUBMITTED'
E       AssertionError: assert 'GRADED' == 'SUBMITTED'
E         - SUBMITTED
E         + GRADED

tests/students_test.py:73: AssertionError
________________________ test_assignment_resubmit_error ________________________

client = <FlaskClient <Flask 'core'>>
h_student_1 = {'X-Principal': '{"student_id": 1, "user_id": 1}'}

    def test_assignment_resubmit_error(client, h_student_1):
        response = client.post(
            '/student/assignments/submit',
            headers=h_student_1,
            json={
                'id': 2,
                'teacher_id': 2
            })
        error_response = response.json
>       assert response.status_code == 400
E       assert 200 == 400
E         +200
E         -400

tests/students_test.py:86: AssertionError
________________________ test_get_assignments_teacher_2 ________________________

client = <FlaskClient <Flask 'core'>>
h_teacher_2 = {'X-Principal': '{"teacher_id": 2, "user_id": 4}'}

    def test_get_assignments_teacher_2(client, h_teacher_2):
        response = client.get(
            '/teacher/assignments',
            headers=h_teacher_2
        )
    
        assert response.status_code == 200
    
        data = response.json['data']
        for assignment in data:
            assert assignment['teacher_id'] == 2
>           assert assignment['state'] in ['SUBMITTED', 'GRADED']
E           AssertionError: assert 'DRAFT' in ['SUBMITTED', 'GRADED']

tests/teachers_test.py:26: AssertionError
_________________________ test_grade_assignment_cross __________________________

client = <FlaskClient <Flask 'core'>>
h_teacher_2 = {'X-Principal': '{"teacher_id": 2, "user_id": 4}'}

    def test_grade_assignment_cross(client, h_teacher_2):
        """
        failure case: assignment 1 was submitted to teacher 1 and not teacher 2
        """
        response = client.post(
            '/teacher/assignments/grade',
            headers=h_teacher_2,
            json={
                "id": 1,
                "grade": "A"
            }
        )
    
>       assert response.status_code == 400
E       assert 200 == 400
E         +200
E         -400

tests/teachers_test.py:42: AssertionError
____________________ test_grade_assignment_draft_assignment ____________________

client = <FlaskClient <Flask 'core'>>
h_teacher_1 = {'X-Principal': '{"teacher_id": 1, "user_id": 3}'}

    def test_grade_assignment_draft_assignment(client, h_teacher_1):
        """
        failure case: only a submitted assignment can be graded
        """
        response = client.post(
            '/teacher/assignments/grade',
            headers=h_teacher_1
            , json={
                "id": 2,
                "grade": "A"
            }
        )
    
>       assert response.status_code == 400
E       assert 200 == 400
E         +200
E         -400

tests/teachers_test.py:99: AssertionError
____________________ test_get_assignments_in_various_states ____________________

    def test_get_assignments_in_various_states():
        """Test to get assignments in various states"""
    
        # Define the expected result before any changes
        expected_result = [('DRAFT', 2), ('GRADED', 2), ('SUBMITTED', 2)]
    
        # Execute the SQL query and compare the result with the expected result
        with open('tests/SQL/number_of_assignments_per_state.sql', encoding='utf8') as fo:
            sql = fo.read()
    
>       sql_result = db.session.execute(text(sql)).fetchall()

tests/SQL/sql_test.py:63: 
_ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ 
env/lib/python3.8/site-packages/sqlalchemy/engine/result.py:992: in fetchall
    return self._allrows()
env/lib/python3.8/site-packages/sqlalchemy/engine/result.py:398: in _allrows
    make_row = self._row_getter
env/lib/python3.8/site-packages/sqlalchemy/util/langhelpers.py:1180: in __get__
    obj.__dict__[self.__name__] = result = self.fget(obj)
env/lib/python3.8/site-packages/sqlalchemy/engine/result.py:319: in _row_getter
    keymap = metadata._keymap
env/lib/python3.8/site-packages/sqlalchemy/engine/cursor.py:1201: in _keymap
    self._we_dont_return_rows()
env/lib/python3.8/site-packages/sqlalchemy/engine/cursor.py:1182: in _we_dont_return_rows
    util.raise_(
_ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ 

    def raise_(
        exception, with_traceback=None, replace_context=None, from_=False
    ):
        r"""implement "raise" with cause support.
    
        :param exception: exception to raise
        :param with_traceback: will call exception.with_traceback()
        :param replace_context: an as-yet-unsupported feature.  This is
         an exception object which we are "replacing", e.g., it's our
         "cause" but we don't want it printed.    Basically just what
         ``__suppress_context__`` does but we don't want to suppress
         the enclosing context, if any.  So for now we make it the
         cause.
        :param from\_: the cause.  this actually sets the cause and doesn't
         hope to hide it someday.
    
        """
        if with_traceback is not None:
            exception = exception.with_traceback(with_traceback)
    
        if from_ is not False:
            exception.__cause__ = from_
        elif replace_context is not None:
            # no good solution here, we would like to have the exception
            # have only the context of replace_context.__context__ so that the
            # intermediary exception does not change, but we can't figure
            # that out.
            exception.__cause__ = replace_context
    
        try:
>           raise exception
E           sqlalchemy.exc.ResourceClosedError: This result object does not return rows. It has been closed automatically.

env/lib/python3.8/site-packages/sqlalchemy/util/compat.py:207: ResourceClosedError
__________ test_get_grade_A_assignments_for_teacher_with_max_grading ___________

    def test_get_grade_A_assignments_for_teacher_with_max_grading():
        """Test to get count of grade A assignments for teacher which has graded maximum assignments"""
    
        # Read the SQL query from a file
        with open('tests/SQL/count_grade_A_assignments_by_teacher_with_max_grading.sql', encoding='utf8') as fo:
            sql = fo.read()
    
        # Create and grade 5 assignments for the default teacher (teacher_id=1)
        grade_a_count_1 = create_n_graded_assignments_for_teacher(5)
    
        # Execute the SQL query and check if the count matches the created assignments
>       sql_result = db.session.execute(text(sql)).fetchall()

tests/SQL/sql_test.py:99: 
_ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ 
env/lib/python3.8/site-packages/sqlalchemy/engine/result.py:992: in fetchall
    return self._allrows()
env/lib/python3.8/site-packages/sqlalchemy/engine/result.py:398: in _allrows
    make_row = self._row_getter
env/lib/python3.8/site-packages/sqlalchemy/util/langhelpers.py:1180: in __get__
    obj.__dict__[self.__name__] = result = self.fget(obj)
env/lib/python3.8/site-packages/sqlalchemy/engine/result.py:319: in _row_getter
    keymap = metadata._keymap
env/lib/python3.8/site-packages/sqlalchemy/engine/cursor.py:1201: in _keymap
    self._we_dont_return_rows()
env/lib/python3.8/site-packages/sqlalchemy/engine/cursor.py:1182: in _we_dont_return_rows
    util.raise_(
_ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ 

    def raise_(
        exception, with_traceback=None, replace_context=None, from_=False
    ):
        r"""implement "raise" with cause support.
    
        :param exception: exception to raise
        :param with_traceback: will call exception.with_traceback()
        :param replace_context: an as-yet-unsupported feature.  This is
         an exception object which we are "replacing", e.g., it's our
         "cause" but we don't want it printed.    Basically just what
         ``__suppress_context__`` does but we don't want to suppress
         the enclosing context, if any.  So for now we make it the
         cause.
        :param from\_: the cause.  this actually sets the cause and doesn't
         hope to hide it someday.
    
        """
        if with_traceback is not None:
            exception = exception.with_traceback(with_traceback)
    
        if from_ is not False:
            exception.__cause__ = from_
        elif replace_context is not None:
            # no good solution here, we would like to have the exception
            # have only the context of replace_context.__context__ so that the
            # intermediary exception does not change, but we can't figure
            # that out.
            exception.__cause__ = replace_context
    
        try:
>           raise exception
E           sqlalchemy.exc.ResourceClosedError: This result object does not return rows. It has been closed automatically.

env/lib/python3.8/site-packages/sqlalchemy/util/compat.py:207: ResourceClosedError
=========================== short test summary info ============================
FAILED tests/principals_test.py::test_grade_assignment_draft_assignment - ass...
FAILED tests/principals_test.py::test_grade_assignment - assert 404 == 200
FAILED tests/principals_test.py::test_regrade_assignment - assert 404 == 200
FAILED tests/students_test.py::test_post_assignment_null_content - assert 200...
FAILED tests/students_test.py::test_submit_assignment_student_1 - AssertionEr...
FAILED tests/students_test.py::test_assignment_resubmit_error - assert 200 ==...
FAILED tests/teachers_test.py::test_get_assignments_teacher_2 - AssertionErro...
FAILED tests/teachers_test.py::test_grade_assignment_cross - assert 200 == 400
FAILED tests/teachers_test.py::test_grade_assignment_draft_assignment - asser...
FAILED tests/SQL/sql_test.py::test_get_assignments_in_various_states - sqlalc...
FAILED tests/SQL/sql_test.py::test_get_grade_A_assignments_for_teacher_with_max_grading
========================= 11 failed, 7 passed in 0.53s =========================
