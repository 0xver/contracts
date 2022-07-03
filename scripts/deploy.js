async function main() {
    // Gets deployer address
    const [deployer] = await ethers.getSigners()
    console.log("Deploying contract(s) with the account:", deployer.address, "\n")
  
    // Deploys Token
    var token = await ethers.getContractFactory("Token")
    const Token = await Token.deploy()
    console.log("Deployed Token", (Token.address).toString(), "\n")
}

main()
    .then(() => process.exit(0))
    .catch(error => {
      console.error(error)
      process.exit(1)
    })
