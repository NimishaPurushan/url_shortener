const rest_api_id = "i4lyj2xvr3"
const deployment = "dev"
const url = "https://localhost:4566/restapis/"+rest_api_id+"/"+deployment+"/_user_request_/url"


async function get_url() {
    const url = "https://localhost:4566/restapis/"+rest_api_id+"/"+deployment+"/_user_request_/urls"
    const response = await fetch(url, {
        method: 'GET'
    });

    if (!response.ok) {
        throw new Error(`HTTP error! Status: ${response.status}`);
    }

    return response.json(); // Return parsed JSON response
}

async function post_url(long_url: string) {
    const url = "https://localhost:4566/restapis/"+rest_api_id+"/"+deployment+"/_user_request_/url/"
    const response = await fetch(url, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json'
        },
        body: JSON.stringify({ long_url })
    });

    if (!response.ok) {
        throw new Error(`HTTP error! Status: ${response.status}`);
    }

    return response.json(); // Return parsed JSON response
}

export async function get_url_by_code(short_code: string) {
    const url = "https://localhost:4566/restapis/"+rest_api_id+"/"+deployment+"/_user_request_/url"
    const response = await fetch(`${url}/${short_code}`, {
        method: "GET",
        headers: {
            "Content-Type": "application/json"
        }
    });

    return response.json();
}

export { post_url, get_url }