**Show a Poll**
----
Returns info about current voting for a Poll
* **URL**

  /api/polls/:id

* **Method:**

  `GET` 
  
*  **URL Params**
    
   * **Required:**
 
        `id=[integer]`   

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

  * **Code:** 401 <br />
    **Content:** `{ errors : "You are not in group!" }`<br/>
    When the user isn't in the group


* **Sample Call:**

* **Notes:**
