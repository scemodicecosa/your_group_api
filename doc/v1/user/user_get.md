**Show User**
----
  Returns info about a single user
* **URL**

  /api/users/:id

* **Method:**

  `GET` 
  
*  **URL Params**
    
   **Required:**
 
   `id=[integer]`


* **Data Params**

  
* **Success Response:**
  
  * **Code:** 200 <br />
    **Content:** `{ id : 12, email: 'prova@example.com', phone_number: 3477956008 }`
 
* **Error Response:**

  * **Code:** 401 <br />
    **Content:** `{ errors : "You are not authorized!" }`


* **Sample Call:**

* **Notes:**
