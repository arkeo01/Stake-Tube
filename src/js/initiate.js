const StakeTube = artifacts.require('StakeTube');

const ether = (n) => {
    return new web3.utils.BN(
        web3.utils.toWei(n.toString(), 'ether')
    )
}

module.exports = async function(callback) {
    try{
        console.log("Executing Initiation Script!");

        // Fetching Accounts
        const accounts =  await web3.eth.getAccounts();
        console.log('Accounts: \n', accounts);
        
        // Fetching the deployed stakeTube
        let stakeTube = await StakeTube.deployed();
        console.log('StakeTube at: ', stakeTube.address);

        // First Run to test everything...
        // Upload Video
        let videoResult = await stakeTube.addVideo('Test 1', 'First Video', {from: accounts[0]});
        console.log('Video Uploaded: ', videoResult);

        // Uploaded Video
        let video = await stakeTube.idToVideo(1);
        console.log('Uploaded Video: ', video);

        // Tip by accounts[1]
        let tipResult = await stakeTube.tip(1, {from: accounts[1], value: ether(10)});
        console.log('10 Ether Tip by accounts[1]: ', tipResult);

        // Tipper Stored in idToTippers Mapping of contract
        let tipper1 = await stakeTube.idToTippers(1, 0);
        console.log('First Tipper', tipper1);

        //Tip by accounts[2]
        tipResult = await stakeTube.tip(1, {from: accounts[2], value: ether(5)});
        console.log('5 Ether Tip by accounts[2]: ', tipResult);

        // Tipper stored in idToTippers Mapping
        let tipper2 = await stakeTube.idToTippers(1, 1);
        console.log('Second Tipper', tipper2);

        // First Run completed
        
        // This Doesn't work!
        // let tippers = await stakeTube.idToTippers(1);
        // console.log('Tippers: ', tippers);

        console.log('Complete Script Executed!');
    }
    catch(err){
        console.error("Ohh Snap!!!", err);
    }

    callback()
}