const main = async () => {
    const domainContractFactory = await hre.ethers.getContractFactory('Domains');
    const domainContract = await domainContractFactory.deploy("smaash");
    await domainContract.deployed();

    console.log("Contract deployed to: ", domainContract.address)

    let txn = await domainContract.register("tanu",  {value: hre.ethers.utils.parseEther('0.1')});
    await txn.wait();
    console.log("Minted domain tanu.smaash");

    txn = await domainContract.setRecord("tanu", "I am a member of the smaash squad!!:-P");
    await txn.wait();
    console.log("Set record for tanu.smaash");


}

const runMain = async () => {
    try {
        await main();
        process.exit(0);
    } catch (error) {
        console.log(error);
        process.exit(1);
    }
}

runMain();