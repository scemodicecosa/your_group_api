**Login as User**
----
  Create a new session for the user. Returns a token to be used for other API
* **URL**

  /api/sessions

* **Method:**

  `POST` 
  
*  **URL Params**
    


* **Data Params**
    ```
    {
      sessions : {
        email : [string], required unless phone_number
        phone_number: [string],required unless email
        password: [alphanumeric] required
      }
    }
    ```


  
* **Success Response:**
  
  * **Code:** 200 <br />
    **Content:** 
    ` { auth_token: 'Aiuubcsiu628xgioAl_lli23'}`
    <br/>
    
    
* **Error Response:**

  * **Code:** 422 <br />
      **Content:** 
      * `{ errors : "Invalid email or password" }`
      * `{ errors : "Invalid phone or password" }`
  * **Code:** 500 <br />
        **Content:** `{ errors : "No email or phone provided" }`
      
      

* **Sample Call:**

* **Notes:**
