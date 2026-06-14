import './App.css';
import BestRest from './Components/BestRest';
import Footer from './Components/Footer';
import Navigate from './Components/Navigate';
import OffersBanner from './Components/OffersBanner';
import RestaurentChain from './Components/RestaurentChain';
import RestaurentOnline from './Components/RestaurentOnline';

function App() {
  return (
    <div>
      <div style={{
        background: '#020706',
        color: 'white',
        textAlign: 'center',
        padding: '8px',
        fontSize: '14px',
        fontWeight: 'bold'
      }}>
        🚀 Version 1.0 — Deployed via Blue-Green DevSecOps Pipeline on AWS ECS
      </div>
      <Navigate/>
      <OffersBanner/>
      <RestaurentChain/>
      <RestaurentOnline/>
      <BestRest/>
      <Footer/>
    </div>
  );
}

export default App;