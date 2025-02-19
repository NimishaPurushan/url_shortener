import { post_url, get_url, get_url_by_code } from "../utils/api";
import * as React from 'react'
import { useState } from 'react'

interface FormElements extends HTMLFormControlsCollection {
  usernameInput: HTMLInputElement
}
interface UsernameFormElement extends HTMLFormElement {
  readonly elements: FormElements
}

function Create(){

    const [short_url, setShortUrl] = useState("");

    const handleSubmit = (e: React.FormEvent<UsernameFormElement>) => {
        e.preventDefault();
        const url = e.currentTarget.elements.usernameInput.value as string;

        if (!url) {
            console.error("URL is required");
            return;
        }
        

        post_url(url)
            .then(data => SetCreatedUrl(data))
            .catch(error => console.error("Error:", error));       
    };

    const SetCreatedUrl = (data:any) => {
        console.log(data);
        if (data.item.short_url) {
            setShortUrl(data.item.short_url);
        }
    }

    const handleGet = () => {
        if (short_url) {
        get_url_by_code(short_url).then(data => console.log(data));
        }
    }

    return (
        <div>
            <h2>Create Short URL</h2>
            <form onSubmit={handleSubmit}>
                <label>Enter URL</label>
                <input type="text" name="url" id="usernameInput"/>
                <button type="submit">Submit</button>
            </form>
            <h2>Short URL</h2>
            <p onClick={handleGet}>{short_url}</p>
        </div>
    )
}

export default Create