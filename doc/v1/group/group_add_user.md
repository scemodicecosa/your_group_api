**Add User to Group**
----
  Adds the new User to the Group, if admin is passed is set to it. The logged user must be an admin <br/>
  **Require Authorization Header**
* **URL**

  /api/groups/:group_id/add_user/:id

* **Method:**

  `POST` 
  
*  **URL Params**
   * **Required:**<br/>
      `group_id=[integer]`<br/>
      `id=[integer]`


* **Data Params**
    `
    { admin : [boolean], optional }
    `


  
* **Success Response:**
  
  * **Code:** 201 <br />
    **Content:** 
    
* **Error Response:**

 
  * **Code:** 401 <br />
      **Content:** `{ errors : "You are not admin!" }`

* **Sample Call:**

* **Notes:**
