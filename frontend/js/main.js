async function getUsers(){
    
    fetch('/api/db/users')
    .then(response=>response.json())
    .then(users => {
        console.log(users)
        // let ul = document.createElement('ul');
        // let users_list = document.getElementById('users_list').append(ul)
        // users.forEach(item => {
        //     let li = document.createElement('li');
        //     ul.appendChild(li);
        //     li.innerHTML += item;
        // });
    
    })
    
    .catch(error =>console.log(error));
}

async function createUser(){
    let user_name = document.getElementById('name').value 
    if(user_name != ''){
        fetch('/api/db/user',{
        method: 'POST',
        body: JSON.stringify(user_name)
        })
        .then(response=>console.log(response))
        .catch(error => console.log(error))
    }

}

