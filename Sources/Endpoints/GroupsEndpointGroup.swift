import Foundation
import RxSwift

/**
 This EndpointGroup communicates with [Group API](https://docs.gitlab.com/ee/api/groups.html)
 # Group API
 ## Valid access levels
 The access levels are defined in the `Gitlab::Access` module. Currently, these levels are recognized:
 ```
 10 => Guest access
 20 => Reporter access
 30 => Developer access
 40 => Maintainer access
 50 => Owner access # Only valid for groups
 ```
 */
public class GroupsEndpointGroup: EndpointGroup {
    internal enum Endpoints {
        case groups
        case groupProjects(groupID: Int)

        var url: String {
          switch self {
          case .groups:
            return "/groups"
          case .groupProjects(let groupID):
            return "/groups/\(groupID)/projects"
          }
        }
    }

    public func getGroups(parameters: QueryParameters? = nil, page: Int = 1, perPage: Int = RxGitLabAPIClient.defaultPerPage) -> Observable<[Group]> {
         var queryParams = parameters ?? QueryParameters()
         queryParams["page"] =  page
         queryParams["per_page"] = perPage
         
         let apiRequest = APIRequest(path: Endpoints.groups.url, parameters: queryParams)
         return object(for: apiRequest)
    }

    public func getGroups(parameters: QueryParameters? = nil) -> Paginator<Group> {
         let apiRequest = APIRequest(path: Endpoints.groups.url, parameters: parameters)
         let paginator = Paginator<Group>(communicator: hostCommunicator, apiRequest: apiRequest)
         return paginator
    }
    
    public func getGroupProjects(groupID: Int, parameters: QueryParameters? = nil, page: Int = 1, perPage: Int = RxGitLabAPIClient.defaultPerPage) -> Observable<[Group]> {
        var queryParams = parameters ?? QueryParameters()
        queryParams["page"] =  page
        queryParams["per_page"] = perPage
        
        let apiRequest = APIRequest(path: Endpoints.groupProjects(groupID: groupID).url, parameters: queryParams)
        return object(for: apiRequest)
    }
      
    public func getGroupProjects(groupID: Int, parameters: QueryParameters? = nil) -> Paginator<Project> {
        let apiRequest = APIRequest(path: Endpoints.groupProjects(groupID: groupID).url, parameters: parameters)
        let paginator = Paginator<Project>(communicator: hostCommunicator, apiRequest: apiRequest)
        return paginator
    }
}
