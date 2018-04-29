**Remove User from Group**
----
  Removes a user from a Group. The logged user must be an admin or the one to remove <br/>
  **Require Authorization Header**
* **URL**

  /api/groups/:group_id/remove_user/:id

* **Method:**

  `DELETE` 
  
*  **URL Params**
   * **Required:**<br/>
      `group_id=[integer]`<br/>
      `id=[integer]`


* **Data Params**

  
* **Success Response:**
  
  * **Code:** 204 <br />
    **Content:** 
    
* **Error Response:**

 
  * **Code:** 401 <br />
      **Content:** `{ errors : "You are not admin or in group" }`

* **Sample Call:**

* **Notes:**
