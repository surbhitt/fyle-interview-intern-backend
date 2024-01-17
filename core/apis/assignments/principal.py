from flask import Blueprint
from core.apis import decorators
from core.apis.responses import APIResponse
from core.libs import assertions
from core.models.assignments import Assignment, AssignmentStateEnum

from .schema import AssignmentGradeSchema, AssignmentSchema
principal_assignments_resources = Blueprint('principal_assignments_resources', __name__)


@principal_assignments_resources.route('/assignments', methods=['GET'], strict_slashes=False)
@decorators.authenticate_principal
def list_assignments(p):
    """Returns list of assignments"""
    principal_assignments = Assignment.get_assignments_submitted_or_graded()
    principal_assignments_dump = AssignmentSchema().dump(principal_assignments, many=True)
    return APIResponse.respond(data=principal_assignments_dump)


@principal_assignments_resources.route('/assignments/grade', methods={'POST'}, strict_slashes=False)
@decorators.accept_payload
@decorators.authenticate_principal
def grade_assignments(p, incoming_payload):
    """Grade assignment"""
    print("\n\n***this was received***\n\n")
    grade_assignment_payload = AssignmentGradeSchema().load(incoming_payload)
    
    assignment = Assignment.get_by_id(grade_assignment_payload.id)
    assertions.assert_found(assignment, 'No assignment found with this id was found')
    assertions.assert_valid(assignment.state == AssignmentStateEnum.SUBMITTED, 'Assignment in draft state can not be graded')

    graded_assignment = Assignment.mark_grade(
        _id=grade_assignment_payload.id,
        grade=grade_assignment_payload.grade,
        auth_principal=p
    )
    db.session.commit()
    graded_assignment_dump = AssignmentSchema().dump(graded_assignment)
    return APIResponse.respond(data=graded_assignment_dump)
    
    
