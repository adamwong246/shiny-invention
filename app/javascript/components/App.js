import React from "react"
import PropTypes from "prop-types"
import {
  useQuery,
  useMutation,
  useQueryClient,
  QueryClient,
  QueryClientProvider,
} from '@tanstack/react-query'
import axios from "axios";

const queryClient = new QueryClient()

class Greeting extends React.Component {

  render() {
    return (
      <React.Fragment>
        <QueryClientProvider client={queryClient}>
          <Products />
        </QueryClientProvider>
      </React.Fragment>
    );
  }
}

function Products() {
  // Access the client
  const queryClient = useQueryClient()

  // Queries
  const { isLoading, error, data, isFetching } = useQuery(["products]"], () =>
    axios
      .get("http://localhost:3000/app.json")
      .then((res) => {
        console.log(data)
        return res.data
      })
  );

  // Mutations
  // const mutation = useMutation({
  //   mutationFn: postTodo,
  //   onSuccess: () => {
  //     // Invalidate and refetch
  //     queryClient.invalidateQueries({ queryKey: ['products'] })
  //   },
  // })

  return (
    <div>
      {/* <ul>
        {
          Object.keys(data).map((k, v) => {
            return (<li>
              {JSON.stringify(v)}
            </li>)
          })
        }
      </ul> */}

      <pre>{JSON.stringify(data, null, 2)}</pre>
      {/* <ul>
        {data?.map(product => (
          <li key={product.id}>{JSON.stringify(product)}</li>
        ))}
      </ul> */}

      {/* <button
        onClick={() => {
          mutation.mutate({
            id: Date.now(),
            title: 'Do Laundry',
          })
        }}
      >
        Add Todo
      </button> */}
    </div>
  )
}


export default Greeting
