const main = async () => {
    const [owner, randomPerson] = await hre.ethers.getSigners();
    const domainContractFactory = await hre.ethers.getContractFactory('Domains');
    const domainContract = await domainContractFactory.deploy();
    await domainContract.deployed();
    console.log("Contract deployed to: ", domainContract.address);
    console.log("Contract deployed by: ", owner.address)
    
    //calling the register function of smart contract
    const txn = await domainContract.register("doom");
    await txn.wait();

    //calling the getAddress function of smart contract 
    const domainOwner = await domainContract.getAddress("doom");
    console.log("Owner of domain: ", domainOwner);

    //calling the setRecord function  
    const setDomainRecord = await domainContract.setRecord("doom", "This is a test record");
    await setDomainRecord.wait();

    //checking whether the require statements are working or not
    // setDomainRecord = await domainContract.connect(randomPerson).setRecord("doom", "I now own the domain👿");
    // await setDomainRecord.wait(); //this will throw an error hence the require statements are working fine

};

const runMain = async () => {
    try{
        await main();
        process.exit(0);
    }
    catch (error){
        console.log(error);
        process.exit(1);
    }
}

runMain();