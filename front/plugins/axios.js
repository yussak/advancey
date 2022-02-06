import axios from "axios";

export default axios.create({
    // baseURL: process.env.API_ENDPOINT_DEV
    baseURL: process.env.API_ENDPOINT_PROD
})