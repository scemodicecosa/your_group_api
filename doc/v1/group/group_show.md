**Show Group**
----
  Returns info about a single group. Logged user must be a member of the group
  <br/> **Require Authorization Header**
* **URL**

  /api/groups/:id

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
        name: 'prova@example.com'
        descriptions: 'scBAXhjggv5RdaAHXXbq:oj'
        users_id: [1,23,43,12]
        actions_id: [12,65,61,73]
    }
    ```
    
* **Error Response:**

  * **Code:** 401 <br />
    **Content:** `{ errors : "You are not authorized!" }`
  * **Code:** 401 <br />
      **Content:** `{ errors : "You are not a member!" }`

* **Sample Call:**

* **Notes:**
