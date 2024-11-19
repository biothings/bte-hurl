from trapi_testing_tools.tests import http

method = "GET"
endpoint = "/v1/asyncquery_status/fakeID"
tests = [http.status(404)]
