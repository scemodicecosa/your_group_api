**Create Group**
----
  Create a new group. The logged user will be the administrator
  **Require Authorization Header**
* **URL**

  /api/groups

* **Method:**

  `POST` 
  
*  **URL Params**
    


* **Data Params**
    ```
    {
      group : {
        name : [string], required unless phone_number
        description : [string],required unless email
      }
    }
    ```


  
* **Success Response:**
  
  * **Code:** 200 <br />
    **Content:** 
    ` { id: 12 }`
    <br/>
    
    
* **Error Response:**

  * **Code:** 400 <br />
    **Content:** `{ errors : "Cannot create group" }`
  * **Code:** 401 <br />
      **Content:** `{ errors : "You are not authorized!" }`

* **Sample Call:**

* **Notes:**
