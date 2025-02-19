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
    const [long_url, setLongUrl] = useState("");

    const handleSubmit = async(e: React.FormEvent<UsernameFormElement>) => {
        e.preventDefault();
        const url = e.currentTarget.elements.usernameInput.value as string;

        if (!url) {
            console.error("URL is required");
            return;
        }
        
        try{
        const response = await post_url(url);  
        if (response.item.short_url) {
            setShortUrl(response.item.short_url);
        }
        }catch(error){
            console.error("Error:", error);
        }     
    };

    const handleGet = async () => {
        if (!short_url) {return;}
        try{
        const data = await get_url_by_code(short_url);
        setLongUrl(data.long_url);
        window.open(data.long_url, "_blank");
        }catch(error){
            console.error("Error:", error);
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
            {short_url &&
           <div>
            <h2>Short URL</h2>
            <a href="#" onClick={handleGet}>
                <p style={{ cursor: "pointer", color: "blue", textDecoration: "underline" }}>
                    {short_url}
                </p>
            </a>
           </div>}
        </div>
    )
}

export default Create