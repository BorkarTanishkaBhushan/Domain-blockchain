const main = async () => {
    const domainContractFactory = await hre.ethers.getContractFactory('Domains');
    const domainContract = await domainContractFactory.deploy("smaash");
    await domainContract.deployed();
    console.log("Contract deployed to: ", domainContract.address);
    
    let txn = await domainContract.register("tanu",  {value: hre.ethers.utils.parseEther('3')});
    await txn.wait();

    const address = await domainContract.getAddress("tanu");
    console.log("Owner of domain tanu:", address);

    const balance = await hre.ethers.provider.getBalance(domainContract.address);
    console.log("Contract balance:", hre.ethers.utils.formatEther(balance));
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