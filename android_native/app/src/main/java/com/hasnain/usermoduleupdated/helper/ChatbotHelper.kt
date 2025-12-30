package com.hasnain.usermoduleupdated.helper

import android.util.Log
import com.hasnain.usermoduleupdated.Constant
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.withContext
import okhttp3.MediaType.Companion.toMediaType
import okhttp3.OkHttpClient
import okhttp3.Request
import okhttp3.RequestBody.Companion.toRequestBody
import org.json.JSONObject
import java.io.IOException
import java.util.concurrent.TimeUnit

object ChatbotHelper {
    private val client = OkHttpClient.Builder()
        .connectTimeout(30, TimeUnit.SECONDS)
        .readTimeout(30, TimeUnit.SECONDS)
        .writeTimeout(30, TimeUnit.SECONDS)
        .build()

    suspend fun getHealthGuidance(prompt: String): String {
        val healthPrompt = "You are a health guidance assistant. Provide accurate and safe advice: $prompt"
        
        return withContext(Dispatchers.IO) {
            try {
                val jsonBody = JSONObject()
                jsonBody.put("model", "gpt-4o")
                jsonBody.put("stream", false)
                
                val messagesArray = org.json.JSONArray()
                val message = JSONObject()
                message.put("role", "user")
                message.put("content", healthPrompt)
                messagesArray.put(message)
                
                jsonBody.put("messages", messagesArray)

                val mediaType = "application/json; charset=utf-8".toMediaType()
                val requestBody = jsonBody.toString().toRequestBody(mediaType)

                val apiKey = Constant.OPENAI_API_KEY.trim()
                val url = Constant.OPENAI_BASE_URL + "chat/completions"
                Log.d("API_DEBUG", "Request URL: $url")
                
                val request = Request.Builder()
                    .url(url)
                    .addHeader("Authorization", "Bearer $apiKey")
                    .addHeader("Content-Type", "application/json")
                    .post(requestBody)
                    .build()

                val response = client.newCall(request).execute()
                val responseBody = response.body?.string()

                if (!response.isSuccessful) {
                    Log.e("API_ERROR", "Unsuccessful response: $responseBody")
                    return@withContext "Error: Request failed with code ${response.code}"
                }

                if (responseBody != null) {
                    Log.d("API_RESPONSE", responseBody)
                    val jsonResponse = JSONObject(responseBody)
                    val choices = jsonResponse.getJSONArray("choices")
                    if (choices.length() > 0) {
                        val firstChoice = choices.getJSONObject(0)
                        val messageObj = firstChoice.getJSONObject("message")
                        return@withContext messageObj.getString("content")
                    }
                }
                
                "Sorry, I couldn't generate a response."
            } catch (e: Exception) {
                Log.e("API_ERROR", "Error: ${e.message}")
                "Error: ${e.message}"
            }
        }
    }
}