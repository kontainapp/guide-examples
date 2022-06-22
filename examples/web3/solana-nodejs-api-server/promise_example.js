async function getNum() {
    const promise = new Promise(resolve => resolve(42));
  
    const num = await promise;
  
    console.log(num); // 👉️ 42
  
    return num;
  }
  
  getNum()
    .then(num => {
      console.log(num); // 👉️ 42
    })
    .catch(err => {
      console.log(err);
    });
  