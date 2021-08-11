import AltairMDKCommon
import AltairMDKProviders

public enum CounterAPI {
    
    #if targetEnvironment(simulator)
    private static let baseUrl = "http://127.0.0.1:3000/api/v1"
    #else
    private static let baseUrl = "http://192.168.68.53:3000/api/v1"
    #endif

    private static let defaultHeaders = [
        "Content-Type": "application/json"
    ]
    
    public static func getCounters<APIResponse>() -> Endpoint<APIResponse> {
        return Endpoint<APIResponse>(headers: defaultHeaders, method: .get, path: baseUrl + "/counters")
    }
    
    public static func createCounter<APIResponse>(title: String) -> Endpoint<APIResponse> {
        var params = Parameters()
        params["title"] = AnyCodable(title)
        return Endpoint<APIResponse>(headers: defaultHeaders, method: .post, path: baseUrl + "/counter", parameters: params)
    }
    
    public static func incrementCounter<APIResponse>(id: String) -> Endpoint<APIResponse> {
        var params = Parameters()
        params["id"] = [id]
        return Endpoint<APIResponse>(headers: defaultHeaders, method: .post, path: baseUrl + "/counter/inc", parameters: params)
    }
    
    public static func decrementCounter<APIResponse>(id: String) -> Endpoint<APIResponse> {
        var params = Parameters()
        params["id"] = [id]
        return Endpoint<APIResponse>(headers: defaultHeaders, method: .post, path: baseUrl + "/counter/dec", parameters: params)
    }
    
    public static func deleteCounter<APIResponse>(id: String) -> Endpoint<APIResponse> {
        var params = Parameters()
        params["id"] = [id]
        return Endpoint<APIResponse>(headers: defaultHeaders, method: .delete, path: baseUrl + "/counter", parameters: params)
    }
    
}
