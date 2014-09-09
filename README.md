WEBTEMPL
========

To store swts

Make sure you change your folder to /WEBTEMPL on your local. Open this folder on MS web matrix. 
Then, add this remote rep and do a pull to get latest changes.

****If you want to overwrite all your local changes from server then, use below commands.

  For example, you have added this remote rep with name: WEBTEMPL. 

  Now, on webmatrix, open shell and paste below commands.

  git fetch WEBTEMPL
  git reset --hard WEBTEMPL/master
  git clean -f -d
