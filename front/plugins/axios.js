import axios from "axios";

export default axios.create({
    baseURL: process.env.NODE_ENV === "production" ? "https://back.pf-advancey.com" : "http://localhost:3000"
})