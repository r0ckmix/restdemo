package org.openapitools.api

import org.junit.jupiter.api.Assertions.assertNotNull
import org.junit.jupiter.api.Test
import org.springframework.http.HttpStatus
import org.springframework.http.ResponseEntity
import kotlin.test.assertEquals

class HelloApiTest {

    private val api: HelloApiController = HelloApiController()

    /**
     * To test HelloApiController.helloGet
     *
     * @throws ApiException
     *          if the Api call fails
     */
    @Test
    fun helloGetTest() {
        val response: ResponseEntity<kotlin.String> = api.helloGet()

        //assertNotNull(null)
        assertNotNull(response)
        assertEquals(response.statusCode, HttpStatus.OK)
        assertEquals(response.body, "Hi!")
    }

}
