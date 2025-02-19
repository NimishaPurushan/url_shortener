import requests
rest_api_id = "i4lyj2xvr3"
deployment = "dev"

def post_req():
    print("post req")
    url = f"http://localhost:4566/restapis/{rest_api_id}/{deployment}/_user_request_/url/"
    #url=f"http://localhost:4566/_aws/execute-api/{rest_api_id}/{deployment}/example"
    resp =requests.options(url, verify=False)
    print("options:",resp.headers, resp.status_code)
    out = requests.post(url, json={"long_url": "https://docs.google.com/document/d/1F2rimwsd21-T4J7DqJtXomusWS2pql0yPOvR-PWlrTQ/edit?tab=t.0"}, verify=False)
    print("actualS:",out.headers, out.status_code)
    return out.json()['item']['short_url']

def get_req(short_url):
    print("get req")
    url = f"https://localhost:4566/restapis/{rest_api_id}/{deployment}/_user_request_/url/{short_url}"
    out = requests.get(url,  verify=False)
    print(out.content,   out.status_code)

def delete_req(short_url):
    print("delete req")
    url = f"https://localhost:4566/restapis/{rest_api_id}/{deployment}/_user_request_/url/{short_url}"
    out = requests.delete(url,  verify=False)
    print(out.json(),   out.status_code)

def put_req(short_url):
    print("put req")
    url = f"https://localhost:4566/restapis/{rest_api_id}/{deployment}/_user_request_/url/{short_url}"
    out = requests.put(url, json={"long_url": "https://chat.com/c/67a4118d-7a88-8006-9512-209d97665d40"}, verify=False)
    print(out.content,   out.status_code)

def get_all_req():
    print("get req")
    url = f"https://localhost:4566/restapis/{rest_api_id}/{deployment}/_user_request_/urls"
    out = requests.get(url,  verify=False)
    print(out.json(),   out.status_code)

# post_req()
short_url = post_req()
# get_all_req()
get_req(short_url)
get_req("23")
# put_req(short_url)
# get_req(short_url)
# delete_req(short_url)
# get_req(short_url)
# get_all_req()