**Show User**
----
  Returns info about a single user
* **URL**

  /api/users/:id

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
    {
        id: 12,
        email: 'prova@example.com'
        auth_token: 'scBAXhjggv5RdaAHXXbq:oj'
    }
    ```
    
* **Error Response:**

  * **Code:** 401 <br />
    **Content:** `{ errors : "You are not authorized!" }`


* **Sample Call:**

* **Notes:**
