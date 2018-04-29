**Create User**
----
  Create a new user
* **URL**

  /api/users

* **Method:**

  `POST` 
  
*  **URL Params**
    


* **Data Params**
    ```
    {
      users : {
        email : [string], required unless phone_number
        phone_number : [string],required unless email
        password : [alphanumeric],
        password_confirmation : [alphanumeric]
      }
    }
    ```


  
* **Success Response:**
  
  * **Code:** 201 <br />
    **Content:** 
    <br/>
    
    
* **Error Response:**

  * **Code:** 401 <br />
    **Content:** `{ errors : "You are not authorized!" }`


* **Sample Call:**

* **Notes:**
