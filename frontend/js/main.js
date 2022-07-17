async function getUsers(){
    fetch('/api/db/users')
    .then(response=>response.json())
    .then(users => {
        let users_list = document.getElementById('users_list');
        users_list.innerHTML = ''

        let ul = document.createElement('ul');
        users.forEach(item => {
            let li = document.createElement('li');
            ul.appendChild(li);
            li.innerHTML += item.name;
        });

        users_list.append(ul)

    })
    
    .catch(error =>console.log(error));
}

async function createUser(){
    let user_name = document.getElementById('name').value;
    data = {
        name : user_name
    };

    if(user_name != ''){
        fetch('/api/db/user',{
            method: 'POST',
            body: JSON.stringify(data),
            headers:{
                'Content-Type': 'application/json'
            }
        })
        .then(response=>console.log(response))
        .catch(error => console.log(error))
    }

}

