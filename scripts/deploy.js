// async function main() {
//   const VoteChain = await ethers.getContractFactory("VoteChain");
//   const voteChain = await VoteChain.deploy();

//   await voteChain.deployed();

//   console.log("VoteChain deployed to:", voteChain.address);
// }

// main()
//   .then(() => process.exit(0))
//   .catch(error => {
//     console.error(error);
//     process.exit(1);
//   });

const {ethers} = require("hardhat");

async function main() {
    const Ballot = await ethers.getContractFactory("Ballot");
    const ballot = await Ballot.deploy([
        {id: 1, name: "Nursultan Nazarbayev", voteCount: 0},
        {id: 2, name: "Abay Qunanbayuli", voteCount: 0},
        {id: 3, name: "Mukhtar Auezov", voteCount: 0},
        {id: 4, name: "Aisulu Alimbekova", voteCount: 0},
        {id: 5, name: "Olzhas Suleimenov", voteCount: 0},
        {id: 6, name: "Dinmukhamed Kunayev", voteCount: 0},
        {id: 7, name: "Shokan Ualikhanov", voteCount: 0},
        {id: 8, name: "Dariga Nazarbayeva", voteCount: 0},
        {id: 9, name: "Kairat Nurdauletov", voteCount: 0},
        {id: 10, name: "Dimash Kudaibergen", voteCount: 0},
    ]);

    console.log(ballot)

    // await ballot.deployTransaction.wait();
    // await Ballot.mint(ballot.target, 90000000);

    console.log("Ballot token deployed to:", ballot.target);
}

main()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error);
        process.exit(1);
    });
