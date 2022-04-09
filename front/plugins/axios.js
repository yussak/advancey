import axios from "axios";

export default axios.create({
  //環境によって条件分岐させたい
    // baseURL: process.env.API_ENDPOINT_DEV
    baseURL: process.env.API_ENDPOINT_PROD
})