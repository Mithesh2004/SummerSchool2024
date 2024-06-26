import { ethers } from "https://cdnjs.cloudflare.com/ajax/libs/ethers/6.6.4/ethers.min.js";

let signer = null;
let provider = null;
let contract = null;

if (window.ethereum == null) {
  alert("Please Install Metamask");
} else {
  provider = new ethers.BrowserProvider(window.ethereum);
}

const contractABI = []; // Replace with your actual contract ABI
const contractAddress = ""; //Replace with your actual contract address

const connectBtn = document.getElementById("connect");
connectBtn.addEventListener("click", connect);

const postForm = document.getElementById("postForm");
postForm.addEventListener("submit", (e) => {
  e.preventDefault();
  postProduct();
});

async function connect() {
  signer = await provider.getSigner();
  contract = new ethers.Contract(contractAddress, contractABI, signer);
  console.log(signer);
}

async function postProduct() {
  const productName = document.getElementById("productName").value;
  const productDescription =
    document.getElementById("productDescription").value;
  const productPrice = ethers.parseEther(
    document.getElementById("productPrice").value
  );

  try {
    console.log("posting Product...");
    const tx = await contract.postProduct(
      productName,
      productDescription,
      productPrice
    );
    await tx.wait();
    console.log("Product posted successfully!");
    alert("Product posted successfully!");
  } catch (error) {
    console.error("Error posting product:", error);
  }
}
