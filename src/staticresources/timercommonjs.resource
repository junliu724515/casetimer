// timercommonjs

var retrieveSessionStorageValue = function(recordId, key) {
    let stringifiedValues = sessionStorage.getItem(recordId);
    if (stringifiedValues) {
       try{
           let sessionStorageValues = JSON.parse(stringifiedValues);
           return sessionStorageValues[key];
       }catch (err){
           console.log(stringifiedValues + ' is not parsable');
       }
    }
    return null;
}

var putSessionStorageValue = function(recordId, key, value) {
    let stringifiedValues = sessionStorage.getItem(recordId);
    if (!stringifiedValues) {
        stringifiedValues = JSON.stringify({});
    }
    let sessionStorageValues = JSON.parse(stringifiedValues);
    sessionStorageValues[key] = value;
    sessionStorage.setItem(recordId, JSON.stringify(sessionStorageValues));
}