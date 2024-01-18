# Fyle Backend Challenge

Attempted to the best of my capability keeping in mind the scope of the assignment. 

I have edited the test for the `test_get_assignments_in_various_states`, the expected value did not align with the actual state of the database itself, due to previous tests, changing the state of the db.

### Install requirements

```
virtualenv env --python=python3.8
source env/bin/activate
pip install -r requirements.txt
```
### Reset DB

```
export FLASK_APP=core/server.py
rm core/store.sqlite3
flask db upgrade -d core/migrations/
```
### Start Server

```
bash run.sh
```
### Run Tests

```
pytest -vvv -s tests/

# for test coverage report
# pytest --cov
# open htmlcov/index.html
```
