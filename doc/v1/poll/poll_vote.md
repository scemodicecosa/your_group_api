**Poll vote**
----
  Vote an answer of the poll. When a user votes twice only the last vote is valid.
* **URL**

  /api/polls/:poll_id/vote/:vote

* **Method:**

  `GET` 
  
*  **URL Params**
    
   * **Required:**
 
        `poll_id=[integer]`<br/>
        `vote=[integer]`   


* **Data Params**

  
* **Success Response:**
  
  * **Code:** 200 <br />
    **Content:** 
    <br/>
    ```
        [
            { answer: 'tutto bene', total: 12 },
            { answer: 'tutto male', total: 7 },
            { answer: 'così così, total: 1},
        ]
    ```
    
* **Error Response:**

  * **Code:** 400 <br />
    **Content:** `{ errors : "Cannot vote for poll" }`<br/>
    When some params are missing or malformed
  * **Code:** 401 <br />
    **Content:** `{ errors : "You are not in group!" }`<br/>
    When the user isn't in the group


* **Sample Call:**

* **Notes:**
