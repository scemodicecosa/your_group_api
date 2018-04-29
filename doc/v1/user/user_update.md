**Update User**
----
  Update attributes of a the logged user
  <br/> **Require Authorization Header**
* **URL**

  /api/users

* **Method:**

  `PATCH` 
  
*  **URL Params**
    
   


* **Data Params**

    ```
    {
        email: [string],
        phone_number: [string]
    }
    ```

  
* **Success Response:**
  
  * **Code:** 201 <br />
    **Content:** 
    
* **Error Response:**

  * **Code:** 422 <br />
    **Content:** `{ errors : "Error updating user" }`
    <br/><br/>
  * **Code:** 401 <br />
    **Content:** `{ errors : "You are not authorized!" }`


* **Sample Call:**

* **Notes:**
